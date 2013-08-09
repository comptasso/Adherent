module Adherent
  module PaymentsHelper
    def list_imputations(payment)
      
      content_tag(:ul) do
          payment.reglements.map do |r|
          content_tag(:li) do
            "Adhésion #{r.adhesion.member.to_s} pour #{number_to_currency(r.amount, locale: :fr)}"
          end
        end.join.html_safe
      end
    end
  end
end
