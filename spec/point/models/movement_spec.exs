defmodule TransferSpec do
  use ESpec

  describe "transfer" do
    context "when transfer an amount between user accounts with same currency" do
      context "when accounts belong to distinct issuers" do
        pending "should transfers an equivalent backup amount between issuer acounts"
        pending "should transfers amount between user acounts"
      end
      context "when accounts belong to same issuers" do
        pending "shouldn't modifies issuer account amount"
        pending "should transfers amount between user accounts"
      end
    end

    context "when transfer an amount between user accounts with distinct currency" do
      context "when accounts belong to distinct issuers" do
        pending "should transfers an equivalent backup amount between issuer acounts"
        pending "should transfers an equivalent amount between users acounts"
      end
      context "when accounts belong to same issuers" do
        pending "shouldn't modify issuer backup amount"
        pending "should transfers an equivalent amount between users acounts"
      end
    end
  end

  describe "deposit" do
    context "when deposit an amount to issuer backup account" do
      pending "should increase account's balance to deposited amount"
    end
    context "when deposit an amount to user account" do
      pending "should increase account's balance to deposited amount"
    end
  end

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
