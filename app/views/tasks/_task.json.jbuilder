json.extract! task, :id, :title, :completed, :list_id, :created_at, :updated_at
json.url task_url(task, format: :json)
