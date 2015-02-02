class BatchPrint < ActiveRecord::Base

  belongs_to :tcc

  attr_accessible :moodle_id, :tcc_id, :must_print, :tcc, :created_at, :updated_at

end
