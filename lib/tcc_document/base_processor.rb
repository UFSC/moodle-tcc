module TccDocument
  class BaseProcessor

    def execute
      raise NotImplementedError
    end

    private

    def latex_path
      File.join(Rails.root, 'latex')
    end

  end
end