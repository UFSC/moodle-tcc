class ServiceController < ApplicationController
  before_filter :check_consumer_key

  def report
    result = get_report_result
    if params[:user_ids]
      render status: :ok, json: result
    else
      render status: :bad_request, json: { error_message: 'Invalid params (missing user_ids)' }
    end
  end

  def get_definition
    result = get_tcc_definition_result
    if params[:tcc_definition_id]
      render status: :ok, json: result
    else
      render status: :bad_request, json: { error_message: 'Invalid params (missing tcc_definition_id)' }
    end
  end

  private

  def get_report_result
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

  def get_tcc_definition_result
    tcc_definition = TccDefinition.find(params[:tcc_definition_id])
    {
      tcc_definition:
      {
        tcc_definition: tcc_definition,
        hubs_definitions: tcc_definition.hub_definitions.map do |hub_definition|
          {
            hub_definition: hub_definition,
            diary_definitions: hub_definition.diary_definitions.map do |diary_definition|
              {
                diary_definition: diary_definition
              }
            end
          }
        end
      }
    }
  end

  def check_consumer_key
    if params[:consumer_key] != TCC_CONFIG['consumer_key']
      render status: :unauthorized, json: { error_message: 'Invalid consumer key' }
    end
  end
end
