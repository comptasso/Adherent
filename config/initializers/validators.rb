# ce validator est utilisé par Payment pour s'assurer que 
# le montant du Payment est effectivement supérieur aux réglements
# qui ont déjà été imputés sur ce paiement.
#
class OverImputationsValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    if (record.reglements.any? && value < record.impute)
      record.errors.add(attribute, :under_imputations)
    end
  end
end