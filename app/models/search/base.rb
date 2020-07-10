module Search
  class Base
    include ActiveModel::Model

    def contain(data, column, value)
      return data if data.count.zero?

      data.where("#{column} LIKE ?", "%#{value}%")
    end

    def exclude(data, column, value)
      return data if data.count.zero?

      data.where.not("#{column} LIKE ?", "%#{value}%")
    end

    def value_to_boolean(value)
      ActiveRecord::Type::Boolean.new.cast(value)
    end

    private

    def data_class(data)
      data[0].class
    end
  end
end
