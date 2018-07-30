class LocalAuthority::Gateway::SequelReturn
  def initialize(database: database)
    @database = database
  end

  def create(new_return)
    @database[:returns].insert(
      project_id: new_return.project_id,
      data: Sequel.pg_json(new_return.data)
    )
  end

  def find_by(id:)
    row = @database[:returns].where(id: id).first
    LocalAuthority::Domain::Return.new.tap do |r|
      r.project_id = row[:project_id]
      r.data = Common::DeepSymbolizeKeys.to_symbolized_hash(row[:data].to_h)
    end
  end
end
