class ServiceController < ApplicationController
  def report
    respond_to do |format|
      if params[:consumer_key] == TCC_CONFIG['consumer_key']
        hubs = get_hubs
        format.json  { render :json => hubs }
      else
        format.json  { render :json => nil }
      end
    end
  end

  private

  def get_hubs
    objects = Array.new
    Tcc.find_all_by_moodle_user(params[:user_ids], select: 'id').each do |tcc|
      objects << tcc.hubs.select(['state', 'hub_definition_id'])
    end
    objects
  end
end
