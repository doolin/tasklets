class TaskLabelValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors.add(attribute, :on_label) unless value && value.length < 64
  end
end
