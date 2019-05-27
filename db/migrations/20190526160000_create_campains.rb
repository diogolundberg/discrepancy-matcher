# frozen_string_literal: true

Sequel.migration do
  up do
    create_table(:campains) do
      primary_key :id
      String :job_id
      String :status
      String :external_reference
      String :ad_description
    end
  end

  down do
    drop_table(:campains)
  end
end
