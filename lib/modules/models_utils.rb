module ModelsUtils

  def update_subtype_field(main, objects)
    # Caso o objeto esteja persistido entao o count tem que ser pelo menos 2, caso contrário
    if (main.persisted? && objects.count > 1) || (!main.persisted? && objects.count >= 1)
      letter = 'a'
      objects.each do |o|
        if o.subtype.nil?
          o.update_column :subtype, letter
        else
          letter = letter.succ unless o.subtype == letter
        end
      end

      main.subtype = letter.succ
    end
  end

end