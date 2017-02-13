ThinkingSphinx::Index.define :question, with: :active_record do
  # fields
  indexes title
  indexes body
end
