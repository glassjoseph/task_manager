require 'sqlite3'

class Task
  attr_reader :title, :description, :id

  def initialize(task_params)
    @description = task_params["description"]
    @title       = task_params["title"]
    @database = SQLite3::Database.new('db/task_manager_development.db')
    @database.results_as_hash = true
    @id = task_params["id"] if task_params["id"]
  end

  def self.all
    #creates new Database OBJECT. Doesn't overwrite existing database, but will create if one doesn't exist.
    database
    tasks = database.execute("SELECT * FROM tasks")
    tasks.map { |task| Task.new(task) }
  end

  def save
    #execute replaces '?'s with additional parameters we give it (@title & @description)
    @database.execute("INSERT INTO tasks (title, description) VALUES (?, ?);", @title, @description)
  end

  def self.find(id)
    database
    task = database.execute("SELECT * FROM tasks WHERE id = ?", id).first
    Task.new(task)
  end

  def self.database
    database = SQLite3::Database.new('db/task_manager_development.db')
    database.results_as_hash = true
    database
  end

end
