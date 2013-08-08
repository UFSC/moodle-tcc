module ModelsUtils

  def update_subtype_field(main, objects)
    unless objects.empty?
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