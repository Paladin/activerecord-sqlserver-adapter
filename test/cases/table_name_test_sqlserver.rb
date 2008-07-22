require "cases/helper"
require 'active_record/schema'

if ActiveRecord::Base.connection.supports_migrations?
  class Order < ActiveRecord::Base
    self.table_name = '[orders]'
  end

  class TableNameTest < ActiveRecord::TestCase
    self.use_transactional_fixtures = false

    # Ensures Model.columns works when using SQLServer escape characters.
    # Enables legacy schemas using SQL reserved words as table names.
    # Should work with table names with spaces as well ('table name').
    def test_escaped_table_name
      assert_nothing_raised do
        ActiveRecord::Base.connection.select_all 'SELECT * FROM [orders]'
      end
      assert_equal '[orders]', Order.table_name
      assert_equal 4, Order.columns.length
    end
  end
end
