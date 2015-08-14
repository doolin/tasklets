class DeviseCreateUsers < ActiveRecord::Migration
  def self.up
    create_table(:users) do |t|

      #t.database_authenticatable :null => false
      t.string :email, :null => false, :default => ''
      t.string :encrypted_password, :null => false, :default => ''

      # recoverable
      t.string :reset_password_token
      t.string :reset_password_sent_at

      # rememberable
      t.datetime :remember_created_at

      # trackable
      t.integer :sign_in_count, :default => 0
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string :current_sign_in_ip
      t.string :last_sign_in_ip

      # t.confirmable
      # t.lockable :lock_strategy => :failed_attempts, :unlock_strategy => :both
      # t.token_authenticatable

      t.timestamps
    end

    add_index :users, :email,                :unique => true
    add_index :users, :reset_password_token, :unique => true
    # add_index :users, :confirmation_token,   :unique => true
    # add_index :users, :unlock_token,         :unique => true
  end

  def self.down
    drop_table :users
  end
end
