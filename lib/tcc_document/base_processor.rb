module TccDocument
  class BaseProcessor

    def execute
      raise NotImplementedError
    end

    protected

    def latex_path
      File.join(Rails.root, 'latex')
    end

  end
end