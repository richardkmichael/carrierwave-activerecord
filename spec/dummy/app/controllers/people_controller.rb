class PeopleController < ApplicationController

  respond_to :html

  def index
    @people = Person.all
  end

# def show
#   begin
#     @person = Person.find_by_id!(params[:id])
#   rescue ActiveRecord::RecordNotFound => e
#     flash[:notice] = 'The person could not be found.'
#     redirect_to people_path
#   end

#   # FIXME: Horrible.  @url_prefix used in view with a manual <a href=... >
#   @url_prefix = 'http://' + request.host_with_port

#   respond_with @person
# end

# def new
#   @person = Person.new
#   @person.avatars.build

#   respond_with @person
# end

# def create
#   begin
#     @person = Person.create!(params[:person])
#   rescue ActiveRecord::RecordInvalid => invalid
#     @person = invalid.record
#   end

#   respond_with @person
# end

# def destroy
#   @person = Person.find_by_id!(params[:id])
#   @person.destroy

#   respond_with @person
# end

end
