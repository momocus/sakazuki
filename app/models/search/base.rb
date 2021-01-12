module Search
  class Base
    include ActiveModel::Model

    def contain(data, column, value)
      return data if data.count.zero?

      data.where("#{column}::text LIKE ?", "%#{value}%")
    end

    private

    def data_class(data)
      data[0].class
    end
  end
end
