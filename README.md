# Carrierwave::ActiveRecord

CarrierWave::ActiveRecord is a CarrierWave plugin which permits it to use
ActiveRecord as the storage provider for file data.

It relies on the ActiveRecord API to be database agnostic.  However, at
this time, it is tested against only SQLite.

## Installation

### Add the gem

Add this line to your Gemfile:

    gem 'carrierwave-activerecord'

And then execute:

    $ bundle

Or install manually:

    $ gem install carrierwave-activerecord

## Usage

To use the ActiveRecord store, add the following to your uploader:

    storage :active_record

### Prepare the database

To store the images, the gem assumes existence of a database table named
`carrier_wave_files` with the following columns:

* original_filename: string
* identifier: string
* content_type: string
* extension: string
* filename: string
* size: integer
* data: binary

### Rails

If you do not have a suitable table, the following Rails migration can be used:

    $ rails g migration create_carrier_wave_files

```ruby
class CreateCarrierWaveFiles < ActiveRecord::Migration
  def change
    create_table :carrier_wave_files do |t|
      t.string :original_filename
      t.string :identifier
      t.string :content_type
      t.string :extension
      t.string :filename
      t.string :size
      t.binary :data

      t.timestamps
    end
  end
end
```

### ActiveRecord connection

If you are already using ActiveRecord as your ORM, the storage provider
will use the existing connection.  Thus, it will work in Rails without
any additional configuration.

If you are not using ActiveRecord as your ORM, you will need to setup
the connection to the database.

### Serving files

The gem assumes there is a web service to handle incoming GET HTTP
requests for the files. For example,

`GET /files/images/sample.png HTTP/1.1`

The file URL is composed of two parts:

* the `downloader_path_prefix`, common to all files
* the `identifier`, particular to each file

The gem provides a new `downloader_path_prefix` configuration option
available to `CarrierWave::Uploader::Base`, the default is `/files`.


## Further reading

### Example project

The following example and test project tracks the gem:
https://github.com/richardkmichael/carrierwave-activerecord-project

### How to add a storage provider

TODO: Link to the wiki page

[3] pry(#<CarrierWave::Mount::Mounter>)> self
=> #<CarrierWave::Mount::Mounter:0x00000102b67aa8
 @column=:file,
 @integrity_error=nil,
 @options={},
 @processing_error=nil,
 @record=
  #<ArticleFile id: 5, file: "my_uploaded_file.txt", article_id: 4, created_at: "2012-06-02 11:42:10", updated_at: "2012-06-02 11:42:10">,
 @uploader=,
 @uploader_options={:mount_on=>nil}>

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
