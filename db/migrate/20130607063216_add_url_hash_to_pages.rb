class AddUrlHashToPages < ActiveRecord::Migration
  def change
  	add_column :pages, :url_hash, :string
  end
end
