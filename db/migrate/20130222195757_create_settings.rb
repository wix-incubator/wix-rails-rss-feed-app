class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
		t.column :key,
    		:string, :null => ''
    	t.column :value,
    		:text, :null => ''
    end
  end
end
