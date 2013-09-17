# encoding: utf-8
class FixInvalidNullReflectionHubs < ActiveRecord::Migration
  def change
    hubs = Hub.where("reflection = '' AND (state != 'draft' AND state != 'new')")
    hubs.with_progress 'Corrigindo hubs com transição incorreta sem reflexão' do |hub|
      hub.state = 'draft'
      hub.save!
    end
  end
end
