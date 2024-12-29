ExUnit.start()

Application.ensure_all_started(:southdown)
Southdown.start_link([])

Mox.defmock(FauxRedix, for: Southdown.Adapter)
