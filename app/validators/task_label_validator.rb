class TaskLabelValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value && value.length < 64
      record.errors.add(attribute, :on_label)
    end
  end
end
