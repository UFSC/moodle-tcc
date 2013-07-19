class ServiceController < ApplicationController
  def report
    respond_to do |format|
      if params[:consumer_key] == TCC_CONFIG['consumer_key']
        hubs = get_hubs
        format.json  { render :json => hubs }
        format.xml  { render :xml => hubs }
      else
        format.json  { render :json => { error_message: 'Invalid consumer key' } }
      end
    end
  end

  private

  def get_hubs
    objects = Array.new
    Tcc.find_all_by_moodle_user(params[:user_ids], select: 'id, moodle_user').each do |tcc|
      objects << {
          user_id: tcc.moodle_user,
          hubs: tcc.hubs.map do |hub|
           {
               grade: hub.grade,
               grade_date: (hub.updated_at if hub.admin_evaluation_ok?),
               state: hub.state,
               state_date: hub.updated_at
           }
          end
      }
    end
    objects
  end
end
