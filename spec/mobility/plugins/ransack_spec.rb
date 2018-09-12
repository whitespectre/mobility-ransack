require "mobility/plugins/ransack"

RSpec.describe Mobility::Plugins::Ransack do

  it "generates correct SQL for translated attributes" do
    expect(Post.ransack(title_cont: "foo", content_eq: "bar").result.to_sql).to eq(
      %q{SELECT "posts".* FROM "posts" INNER JOIN "mobility_string_translations" "Post_title_en_string_translations" ON "Post_title_en_string_translations"."key" = 'title' AND "Post_title_en_string_translations"."locale" = 'en' AND "Post_title_en_string_translations"."translatable_type" = 'Post' AND "Post_title_en_string_translations"."translatable_id" = "posts"."id" INNER JOIN "mobility_text_translations" "Post_content_en_text_translations" ON "Post_content_en_text_translations"."key" = 'content' AND "Post_content_en_text_translations"."locale" = 'en' AND "Post_content_en_text_translations"."translatable_type" = 'Post' AND "Post_content_en_text_translations"."translatable_id" = "posts"."id" WHERE ("Post_title_en_string_translations"."value" LIKE '%foo%' AND "Post_content_en_text_translations"."value" = 'bar')}
    )
  end

  it "finds correct records with translated search queries" do
    posts = %w[foo foo123 123foo].map { |title| Post.create(title: title) }

    aggregate_failures do
      expect(Post.ransack(title_cont: "foo").result.to_a).to match_array(posts)
      expect(Post.ransack(title_start: "foo").result.to_a).to match_array(posts[0..1])
      expect(Post.ransack(title_end: "foo").result.to_a).to match_array([posts[0], posts[2]])
    end
  end
end