# frozen_string_literal: true

# Tasks need a way to be identified regardless of their
# position in a particular tree. Specifically, a table may
# contain multiple "trees", that is, tasks with parent_id
# NULL. Acquiring a task tree for a particular root node
# requires selecting that root node correctly, for which
# the label is used.
class TaskLabelValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors.add(attribute, :on_label) unless value && value.length < 64
  end
end
