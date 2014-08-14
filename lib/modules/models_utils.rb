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

  def get_records(table, columns, first_author, second_author, third_author, year)
    t = table.arel_table
    return table.where(
        t[columns[0]].eq(first_author).and(t[columns[1]].eq(second_author)).and(t[columns[2]].eq(third_author))
        .or(t[columns[0]].eq(first_author).and(t[columns[1]].eq(third_author)).and(t[columns[2]].eq(second_author)))
        .or(t[columns[0]].eq(second_author).and(t[columns[1]].eq(first_author)).and(t[columns[2]].eq(third_author)))
        .or(t[columns[0]].eq(second_author).and(t[columns[1]].eq(third_author)).and(t[columns[2]].eq(first_author)))
        .or(t[columns[0]].eq(third_author).and(t[columns[1]].eq(first_author)).and(t[columns[2]].eq(second_author)))
        .or(t[columns[0]].eq(third_author).and(t[columns[1]].eq(second_author)).and(t[columns[2]].eq(first_author)))
        .and(t[:year].eq(year))
    ).to_a
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