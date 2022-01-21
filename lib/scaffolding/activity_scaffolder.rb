require_relative "activity_transformer"

module Scaffolding::ActivityScaffolder
  def scaffold_activity model, parent_models
    parent_models = parent_models.split(",")
    parent_models += ["Team"]
    parent_models = parent_models.map(&:classify).uniq

    transformer = Scaffolding::ActivityTransformer.new(model, parent_models)

    puts output = `bin/rails g migration #{transformer.transform_string("add_scaffolding_completely_concrete_tangible_thing_to_activity_versions scaffolding_completely_concrete_tangible_thing:references")}`

    if output.include?("conflict") || output.include?("identical")
      puts "\n👆 No problem! Looks like you're re-running this Super Scaffolding command. We can work with the model already generated!\n".green
    end

    migration_file_name = `grep "add_reference :activity_versions, :#{transformer.transform_string("scaffolding_completely_concrete_tangible_thing")}" db/migrate/*`.split(":").first
    legacy_replace_in_file(migration_file_name, "null: false", "null: true")
    legacy_replace_in_file(migration_file_name, "foreign_key: true", "foreign_key: false")

    transformer.scaffold_activity





  end

  def show_activity_help
    puts ""
    puts "🚅  usage: bin/super-scaffold activity <Model> <ParentModel[s]>"
    puts ""
    puts "E.g. to add activity to a Project model that belongs to team:"
    puts ""
    puts "  bin/super-scaffold activity Project Team"
    puts ""
    puts "E.g. to add activity to a Document model that belongs to Team through a Project"
    puts ""
    puts "  bin/super-scaffold activity Document Project,Team"
    puts ""
    puts "Give it a shot! Let us know if you have any trouble with it! ✌️"
    puts ""
    exit
  end
end