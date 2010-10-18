=begin rdoc

= SixArm Ruby Gem: Easy Controller for RESTful resource controller

Author:: Joel Parker Henderson, joelparkerhenderson@gmail.com
Copyright:: Copyright (c) 2006-2010 Joel Parker Henderson
License:: CreativeCommons License, Non-commercial Share Alike
License:: LGPL, GNU Lesser General Public License

=end

module EasyController


 # Return the controller's model
 #
 # ==Example
 #   users_controller.model => User
 #
 # Typically this is the first part of the controller's singular name.
 #
 # Override this if you want a controller with a nonstandard model

 def model
  return @model ||= controller_model
 end


 # Return the controller's param key for form inputs.
 #
 # ==Example
 #
 #   users_controller.paramkey => 'user'
 #
 # Typically this is the controller model name in lowercase.
 #
 # Override this if you want page views with an atypical param key 

 def paramkey
  return @paramkey ||= controller_model_name.downcase
 end


 def single_name
  paramkey
 end

 def collection_name
  .pluralize
 end


 # Find model records
 #
 # ==Example
 #   users_controller.find(x) => User.find(x)

 def find(*a)
  find_before
  model.find(a)
  find_after
 end

 def find_before
 end
 
 def find_after
 end


 
 protected


 ######################################################################
 #
 #  customization
 #
 ######################################################################


 # Return a record object.
 #
 # This method does what you typically want: model.find(param[:id])
 #
 # ==Example
 #   object => User.find(param[:id])
 #
 # To return a custom object, override this method

 def object(*a)
  @object ||= model.find(param[:id])
 end


 # Return a record collection, typically by doing a model find :all with param id.
 #
 # This method does what you typically want: model.find(:all)
 #
 # ==Example
 #   objects => User.find(:all)
 #
 # To return a custom object, override this method

 def objects(*a)
  @objects ||= model.find(:all)
 end


 ######################################################################
 #
 #  index
 #
 ######################################################################

 def index(*a)
  index_before(a)
  index_objects(a)
  index_after(a)
 end

 def index_before(*a)
 end

 def index_objects(*a)
  objects(a)
 end

 def index_after(*a)
 end


 ######################################################################
 #
 #  show
 #
 ######################################################################  

 def show(*a)
  show_before(a)
  show_object(a)
  show_after(a)
 end

 def show_before(*a)
 end

 def show_object(*a)
  object(a)
 end

 def show_after(*a)
 end


 ######################################################################
 #
 #  new
 #
 ######################################################################  

 def new(*a)
  new_before(a)
  new_object(a)
  new_after(a)
 end

 def new_before(*a)
 end

 def new_object(*a)
  model.new(param)
 end

 def new_after(*a)
 end


 ######################################################################
 #
 #  create
 #
 ######################################################################  

 def create(*a)
  create_before(*a)
  a = create_with_params(params)
  if a.save
   create_success(a)
  else
   create_failure(a)
  end
  create_after
  a
 end


 protected


 def create_before(*a)
 end

 def create_after(*a)
 end
  
 def create_with_params
  a = model.new(params[paramkey])
 end

 def create_success(a)
  flash[:notice]=create_success_message(a)
  redirect_to :action => 'list'
 end
 
 def create_failure(a)
  flash[:notice]=create_failure_message
 end


 def create_success_message
  'Created.'
 end

 def create_failure_message
  'Create failed.'
 end


 ######################################################################
 #
 #  edit
 #
 ######################################################################  

 def edit
  id = params['id']
  foreign
  case id
  when "new","0",nil
   return edit_new
  else
   return edit_id(id)
  end  
 end


 def edit_new(a=nil)
  logger.info "+edit id=#{id}" 
  logger.info "+edit_new" 
  a ||= model.new(params[paramkey])
  if request.post?
    logger.info "=edit_new request post id=#{a.id}"
   if a.save
    notice(:create_success)
    edit_next
   else
    warning(:create_warning,a.to_s)
   end
  else
   logger.info "=edit_new request get" 
  end
   logger.info "-edit_new id=#{a.id}" 
  a
 end

 
 def edit_id(id)
   logger.info "+edit_id id=#{id}" 
  if !id then raise "id missing" end
  a = find_by_id(id)
   if !a then raise "id not found: #{id}" end
  if request.post?
    logger.info "=edit_id request post id=#{a.id}" 
   if a.update_attributes(params[paramkey])
    notice(:update_success)
    edit_next
   else
    warning(:update_warning)
   end
  else
    logger.info "=edit_id request get id=#{a.id}" 
  end
   logger.info "-edit_id id=#{id}" 
  a
 end


 def edit_next
  redirect_to :action => 'list'
 end


 ######################################################################
 #
 #  destroy
 #
 ######################################################################  

 def destroy
  destroy_before
  id = params['id']

  if !id
   destroy_error_id_is_missing
   return
  end

  a = destroy_find(id)

  if !a
   destroy_error_id_not_found
   return
  end

  begin
   a.destroy
   destroy_success
  rescue
   destroy_failure
  end

  destroy_after

 end


 def destroy_error_id_missing
  raise "id missing"
 end

 def destroy_error_id_not_found(id)
  raise "id not found: #{id}"
 end

 def destroy_find(*a)
  model.find(a)
 end
  
 def destroy_success
  flash[:notice]=destroy_success_message
 end

 def destroy_success_message
  'Deleted.'
 end

 def destroy_failure
  flash[:warning]=destroy_failure_message
 end

 def destroy_failure_message
  'Delete failed.'
 end

 alias_method destroy_flash destroy_success_method



 ######################################################################
 #
 #  destroy many
 #
 ######################################################################  

 def destroy_many(ids)
   logger.info "+destroy ids=" + ids.join(" "); 
   ids.each{|id| find_by_id(id).destroy }
   notice(:destroy_success, ids.join(" "))
   destroy_next
   logger.info "-destroy_many"
 end

 def destroy_next
  redirect_to :action => 'list'
 end



 ######################################################################
 #
 #  destroy ajax
 #
 ######################################################################  

 def destroy_ajax
  id = params['id']
   logger.info "+destroy_ajax id=#{id}" 
  if !id then raise "id missing" end
  a = find_by_id(id)
   if !a then raise "id not found: #{id}" end
  a.destroy
  render :text => ''
  logger.info "-destroy_ajax" 
 end


 def test
 end


 ######################################################################
 #
 #  cloner
 #
 ######################################################################  


 def cloner
  logger.info "+cloner"
  id = params['id']
  if !id then raise "id missing" end
  a = find_by_id(id)
   if !a then raise "id not found: #{id}" end
  a = a.clone
  a.attributes=params[paramkey]
  a
 end


 ######################################################################
 #
 #  export
 #
 ######################################################################  

 def export
  send_data_to_csv(exporter_data,exporter_filename)
 end

 
 def exporter_data
  foreign
  build=''
  find(:all).each {|x|  build << exporter_line(x) }
  return build
 end

 
 def exporter_line (x)
  fields = exporter_fields(x)
  return CSV.generate_line(fields)+"\n"
 end

 
 def exporter_fields (x)
  return x.to_a
 end

 
 def exporter_filename
  return model.to_s.downcase
 end

 
 def send_data_to_csv(data,filename)
  send_data data, :filename =>  "#{filename}.csv", :type => 'text/plain'
 end


end
