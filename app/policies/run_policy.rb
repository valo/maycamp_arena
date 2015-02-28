class RunPolicy < ApplicaitonPolicy
  def show?
    has_access_to_run?
  end

  def index?
    has_access_to_run?
  end

  def destroy?
    has_access_to_run?
  end

  def update?
    has_access_to_run?
  end

  private

  def has_access_to_run?
    user && (user.admin? || user.id == record.user_id)
  end
end
