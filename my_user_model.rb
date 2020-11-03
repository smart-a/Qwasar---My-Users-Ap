require 'sqlite3'

class User

    def self.connect
        begin
            @db = SQLite3::Database.open "db.sql"
            @db.execute "CREATE TABLE IF NOT EXISTS users(Id INTEGER PRIMARY KEY, 
                                                firstname string, lastname string, age integer,  
                                                password string, email string)"
            
        rescue SQLite3::Exception => e 
            puts "Exception occurred"
            puts e
        end
    end

    def self.create(*user_info)
        connect()
        begin
            user_info = user_info.join(',').split(',')
            user = 'null,' + user_info.map{|u| "'#{u}'"}.join(',')

            @db.execute "INSERT INTO users VALUES(#{user})"
            return "You have successfully sign up"
        rescue SQLite3::Exception => e 
            puts "Exception occurred"
            puts e
        ensure
            @db.close if @db
        end
    end

    def self.get(user_id)
        connect()
        begin
            sql = @db.prepare "SELECT * FROM users WHERE Id='#{user_id}'"
            rs = sql.execute
            fetch = rs.next
            key = ['Id','firstname','lastname','age','password','email']
            user_hash = {}
            index = 0
            key.each{|k|
                user_hash[k] = fetch[index]
                index += 1
            }
            return user_hash
        rescue SQLite3::Exception => e 
            puts "Exception occurred"
            puts e
        ensure
            sql.close if sql
            @db.close if @db
        end
    end

    def self.all
        connect()
        begin
            sql = @db.prepare "SELECT * FROM users"
            rs = sql.execute
            fetch = []
            while (row = rs.next) do
                fetch << row
            end
            key = ['Id','firstname','lastname','age','password','email']
            user_array = []
            fetch.each{|user| 
                index = 0
                user_hash = {}
                key.each{|k|
                    user_hash[k] = user[index]
                    index += 1
                }
                user_array << user_hash
            }   
            return user_array
        rescue SQLite3::Exception => e 
            puts "Exception occurred"
            puts e
        ensure
            sql.close if sql
            @db.close if @db
        end
    end

    def self.update(user_id, attribute, value)
        connect()
        begin
            @db.execute "UPDATE users SET #{attribute}='#{value}' WHERE Id='#{user_id}'"
            return "User record updated"
        rescue SQLite3::Exception => e 
            puts "Exception occurred"
            puts e
        ensure
            @db.close if @db
        end
    end

    def self.destroy(user_id)
        connect()
        begin
            @db.execute "DELETE FROM users WHERE Id='#{user_id}'"
            return "User record deleted"
        rescue SQLite3::Exception => e 
            puts "Exception occurred"
            puts e
        ensure
            @db.close if @db
        end
    end

    def self.all_no_password
        connect()
        begin
            sql = @db.prepare "SELECT firstname,lastname,age,email FROM users"
            rs = sql.execute
            fetch = []
            while (row = rs.next) do
                fetch << row
            end
            key = ['firstname','lastname','age','email']
            user_array = []
            fetch.each{|user| 
                index = 0
                user_hash = {}
                key.each{|k|
                    user_hash[k] = user[index]
                    index += 1
                }
                user_array << user_hash
            }   
            return user_array
        rescue SQLite3::Exception => e 
            puts "Exception occurred"
            puts e
        ensure
            sql.close if sql
            @db.close if @db
        end
    end

    def self.sign_in(email, password)
        connect()
        begin
            sql = @db.prepare "SELECT * FROM users WHERE email='#{email}' AND password='#{password}'"
            rs = sql.execute
            fetch = rs.next
            key = ['Id','firstname','lastname','age','password','email']
            user_hash = {}
            index = 0
            if fetch
                key.each{|k|
                    user_hash[k] = fetch[index]
                    index += 1
                }
            else
                user_hash = nil
            end
            return user_hash
        rescue SQLite3::Exception => e 
            puts "Exception occurred"
            puts e
        ensure
            sql.close if sql
            @db.close if @db
        end
    end

end