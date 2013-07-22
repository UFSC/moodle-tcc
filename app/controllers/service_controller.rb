class ServiceController < ApplicationController
  def report
    respond_to do |format|
      if params[:consumer_key] == TCC_CONFIG['consumer_key']
        result = get_result
        if params[:user_ids]
          format.json  { render :json => result }
        else
          format.json  { render :json => { error_message: 'Invalid params (missing user_ids)' } }
        end
      else
        format.json  { render :json => { error_message: 'Invalid consumer key' } }
      end
    end
  end

  private

  def get_result
    Tcc.find_all_by_moodle_user(params[:user_ids], select: 'id, moodle_user').map do |tcc|
      {
      tcc:
        {
          user_id: tcc.moodle_user,
          hubs: tcc.hubs.order(:position).map do |hub|
            {
              grade: hub.grade, # Nota
              grade_date: hub.grade_date, # Data da nota
              state: hub.state, # Estado
              position: hub.position, # Posição que identifica o eixo
              state_date: hub.updated_at #Data em que estado foi alterado
            }
          end
        }
      }
    end
  end
end
