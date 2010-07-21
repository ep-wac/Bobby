class BobbyCreateTables < ActiveRecord::Migration
   def self.up
     create_table :permissions do |t|
       t.string :name
       t.string :actions_allowed
       t.text   :on_tables

       t.timestamps
     end
     create_table :roles do |t|
       t.string :name

       t.timestamps
     end
     create_table :authorisations do |t|
       t.references :authorisable, :polymorphic => true 
       t.integer :role_id

       t.timestamps
     end
     create_table :permissions_roles, :id => false do |t| 
       t.integer :permission_id
       t.integer :role_id

       t.timestamps
     end
     create_table :group_users do |t|
       t.string :name

       t.timestamps
     end
     create_table :group_users_users, :id => false do |t| 
       t.integer :group_user_id
       t.integer :user_id

       t.timestamps
     end

   end

   def self.down
     drop_table :group_users_users
     drop_table :group_users
     drop_table :permissions_roles
     drop_table :authorisations
     drop_table :roles
     drop_table :permissions
   end
end
