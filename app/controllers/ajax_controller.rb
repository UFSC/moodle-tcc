class AjaxController < ApplicationController

  def build
    @references = Tcc.first.references.collect {|r| r.element}
    render :action => 'build', :layout => false
  end
end
