# Carrierwave::Activerecord

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'carrierwave-activerecord'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install carrierwave-activerecord

## Usage

TODO: Write usage instructions here

To use the activerecord store add the following line to your uploader:

    storage :active_record

The gem currently assumes that there is a table in the database with the name
<pre>carrier_wave_files</pre> to store the images in. This table must have the
following columns:

* original_filename: string
* content_type: string
* extension: string
* filname: string
* size: integer
* data: binary
* storage_path: string

### ActiveRecord specifics

The gem needs a database connection. Inside a rails app the default connection
can be used. For the usage in a non-rails environment ensure that the datatabase
connection is ready before starting to store files with an uploader.

### How to get files back from the db

The gem assumes that there is a service that is responsible to handle web
requests for the files in the db. The Service should be able to handle a HTTP
request like this:

GET /files/images/sample.png HTTP/1.1

The path of the files is composed of two parts:

* the downloader_path_prefix for routing issues
* and the storage_path of the file

The downloader_path_prefix can be configured with the downloader_path_prefix
option available to CarrierWave::Uploader::Base

TODO Example

It defaults to "/files".

The storage path is a property of each file in the db. It is defined by calling
the identifier method on the uploader.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

If you like the work we've done so far and you encounter some issues please
invest some of your time to enhance the code and create a pull request.
