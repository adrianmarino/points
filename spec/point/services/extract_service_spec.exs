defmodule Point.MovementServiceSpec do
  use ESpec

  let amount: Decimal.new 10.1234567891

  describe "extract" do
    context "when extract an amount from a issuer backup account" do
      context "when the account has more than the needed backup amount" do
        pending "should decrements account to required amount"
      end
      context "when the account amount is less that or equal to expected backup amount" do
        pending "shouldn't allows extract required amount"
      end
    end
  end
end
