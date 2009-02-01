class AddingClassposMenuItem < ActiveRecord::Migration
  def self.up
  # execute "INSERT INTO actions (id ,menu_text ,menu_order ,menu_action ,controller) VALUES ( NULL , 'New Class-Based Positive ', '0', 'classpos', 'positives');" 
  # execute "INSERT INTO accesses (action_id,group_id) VALUES ('58', '1');"
  end

  def self.down
  Action.find_by_menu_text("New Class-Based Positive ").destroy
  Access.find_by_action_id(58).destroy
  end
end
