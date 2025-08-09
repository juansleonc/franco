module Dedup
  class TenantMatcher
    def call(fuzzy: false)
      exact_dups = Tenant.group(:full_name).having("count(*) > 1").count.map do |full_name, count|
        ids = Tenant.where(full_name: full_name).order(:created_at).pluck(:id)
        { entity: "tenants", criterion: "full_name", value: full_name, ids: ids, count: count, score: 1.0 }
      end
      return exact_dups unless fuzzy

      # Fuzzy: same domain and similar names
      candidates = []
      tenants = Tenant.select(:id, :full_name, :email).to_a
      by_domain = tenants.group_by { |t| t.email.to_s.split("@").last }
      by_domain.each_value do |arr|
        arr.combination(2).each do |a, b|
          next if a.email == b.email
          name_score = similarity(a.full_name.to_s.downcase, b.full_name.to_s.downcase)
          if name_score >= 0.7
            candidates << { entity: "tenants", criterion: "name_fuzzy", value: { a: a.full_name, b: b.full_name }, ids: [ a.id, b.id ], count: 2, score: name_score }
          end
        end
      end
      exact_dups + candidates
    end

    private

    def similarity(a, b)
      # Jaccard over bigrams (simple, dependency-free)
      sa = bigrams(a)
      sb = bigrams(b)
      return 0.0 if sa.empty? && sb.empty?
      inter = (sa & sb).size.to_f
      union = (sa | sb).size.to_f
      inter / union
    end

    def bigrams(s)
      s = s.gsub(/\s+/, " ").strip
      return [] if s.length < 2
      (0..s.length - 2).map { |i| s[i, 2] }.uniq
    end
  end
end
