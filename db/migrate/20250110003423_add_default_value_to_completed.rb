class AddDefaultValueToCompleted < ActiveRecord::Migration[8.0]
  def change
    change_column_default :tasks, :completed, false
  end
end
