module TccDocument
  class BaseProcessor

    def latex_path
      File.join(Rails.root, 'latex')
    end

  end
end