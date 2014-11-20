class ActionsController < ApplicationController
  before_filter :signed_in_user

  def index
    @actions = Action.all_for_users(current_user.id).order_due;
    respond_to do |format|
      format.html
      format.csv { send_data Action.to_csv(@actions) }
    end
  end

  def new
    referer = request.referer
    referer_type = referer.split('/')[-2]
    referer_id = referer.split('/')[-1]
    session[:return_to] = referer
    @type = Action::TYPE_HASH_BY_REFERER[referer_type]
    if @type.nil?
      @action_item = Action.new
      @works = current_user.works.order_title.all
      @venues = current_user.venues.order_name.all
      @clients = current_user.clients.order_name.all
    else
      object = objectGivenTypeFromReferer(@type, referer_id)
      @crumb_name = crumbNameGivenType(@type, object)
      @crumb_path = crumbPathGivenType(@type, object)
      @action_item = Action.new(actionable_type: @type[:type], actionable_id: object.id)
      @works = []
      @venues = []
      @clients = []
    end
    logger.debug "*** New Action_item: #{@action_item.attributes.inspect}"
  end

  def edit
    @action_item = Action.find(params[:id])
    @type = Action::TYPE_HASH_BY_TYPE[@action_item.actionable_type]
    @object = objectGivenTypeFromAction(@type, @action_item.actionable_id)
    @crumb_name = crumbNameGivenType(@type, @object)
    @crumb_path = crumbPathGivenType(@type, @object)
  end

  def create
    session[:return_to] ||= request.referer
    @action_item = Action.new(params[:action_item])
    if @action_item.actionable_type == "User"
      @action_item.actionable_id = current_user.id
    end
    if @action_item.save
    #  flash[:success] = "Your params #{params[:action]}!"
      redirect_to session.delete(:return_to)
    else
      @type = Action::TYPE_HASH_BY_TYPE[@action_item.actionable_type]
      object = objectGivenTypeFromAction(@type, @action_item.actionable_id)
      @crumb_name = crumbNameGivenType(@type, object)
      @crumb_path = crumbPathGivenType(@type, object)
      render 'new'
    end
  end

  def update
    @action_item = Action.find(params[:id])
    if @action_item.update_attributes(params[:action_item])
      flash[:success] = "Changes have been saved!"
      redirect_to actions_path
    else
      @type = Action::TYPE_HASH_BY_TYPE[@action_item.actionable_type]
      object = objectGivenTypeFromAction(@type, @action_item.actionable_id)
      @crumb_name = crumbNameGivenType(@type, object)
      @crumb_path = crumbPathGivenType(@type, object)
      render 'edit'
    end
  end

  def update_multiple
    session[:return_to] = request.referer
    ids = []
    params[:actions].keys.each do |id|
      ids.push(id)
    end
    @actions = Action.update(params[:actions].keys, params[:actions].values).reject { |w| w.errors.empty? }
    if @actions.empty?
      flash[:notice] = "Actions have been updated!"
      redirect_to session.delete(:return_to)
    else
      render 'new'
    end
  end

  def objectGivenTypeFromReferer(type, ref)
    if type == Action::WORK
      object = current_user.works.find_by_inventory_id(ref)
    elsif type == Action::VENUE
      object = current_user.venues.find_by_munged_name(ref)
    elsif type == Action::CLIENT
      object = current_user.clients.find_by_munged_name(ref)
    elsif type == Action::USER 
      object = User.find(id)
    end
    object
  end

  def objectGivenTypeFromAction(type, id)
    if type == Action::WORK
      object = current_user.works.find(id)
    elsif type == Action::VENUE
      object = current_user.venues.find(id)
    elsif type == Action::CLIENT
      object = current_user.clients.find(id)
    elsif type == Action::USER 
      object = User.find(id)
    end
    object
  end

  def crumbNameGivenType(type, object)
    if type == Action::WORK
      crumb_name = object.title
    elsif type == Action::VENUE
      crumb_name = object.name
    elsif type == Action::CLIENT
      crumb_name = object.name
    elsif type == Action::USER
      crumb_name = object.name
    end
    crumb_name
  end

  def crumbPathGivenType(type, object)
    if type == Action::WORK
      crumb_path = work_path(object)
    elsif type == Action::VENUE
      crumb_path = venue_path(object)
    elsif type == Action::CLIENT
      crumb_path = client_path(object)
    elsif type == Action::USER
      crumb_path = user_path(object)
    end
    crumb_path
  end
end
