# encoding: utf-8
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

  def update_refs(objects)
    if objects.size == 1
      objects.first.update_column :subtype, nil
    elsif objects.size > 1
      order_subtype_fields(objects)
    end
  end

  private

  def order_subtype_fields(objects)
    letter = 'a'
    objects.each do |o|
      o.update_column :subtype, letter
      letter = letter.succ
    end
  end

end