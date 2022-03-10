### A Pluto.jl notebook ###
# v0.18.1

using Markdown
using InteractiveUtils

# ╔═╡ 19731e2c-a09f-11ec-053c-e5c07ed14eeb
begin
	import Pkg
	Pkg.activate(Base.current_project())
	using Revise, VOTables, DataFrames, HTTP, HTTP.URIs, PlutoUI, CSV
end

# ╔═╡ e4a3469b-e3cd-4d69-bc0e-7730037dffcf
md"""
## Simbad -- [sim-script](http://simbad.u-strasbg.fr/guide/sim-url.htx)

Simbad has its own scripting language 😮 
"""

# ╔═╡ ad392537-8502-4304-b722-c79fbee6edde
script = """
output console=off script=off
votable {
    MAIN_ID
    RA(s)
    DEC(s)
    PLX(V)
    FLUX(V)
    FLUX(G)
    FLUX(H)
}
votable open
set radius 5m
query around HD 32297
votable close
""" |> escapeuri;

# ╔═╡ bf63f661-6983-4b59-b6c6-6527f165aba6
res = HTTP.get("https://simbad.u-strasbg.fr/simbad/sim-script";
	query = "script=$script"
);

# ╔═╡ fff97d31-471d-4523-8190-8ce05a30eba8
doc = VOTable(String(res.body))

# ╔═╡ 274013c1-c691-46a5-bcf0-8e3d6077fdff
tbl = DataFrame(doc[1])

# ╔═╡ 60dfbacc-42fd-40a2-a0ac-816c287cea11
names(doc[1])

# ╔═╡ aef54862-2292-4949-b3e7-333667902c9d
VOTables.units(doc[1])

# ╔═╡ caf98e0a-aa92-467d-a2eb-b646662e243b
md"""
## Exoplanet archive -- [TAP](https://exoplanetarchive.ipac.caltech.edu/docs/TAP/usingTAP.html)

Follows the [ADQL](https://www.ivoa.net/documents/latest/ADQL.html) spec used by Vizier, Simbad, others?

Let's start by downloading some data in VOTable format:
"""

# ╔═╡ fbad1e29-e582-4228-9188-292f096d9862
query_exoarchive = """
SELECT TOP 10
hostname, pl_name, tic_id, rastr, decstr, sy_jmag
FROM pscomppars
WHERE tran_flag=1
""" |> escapeuri;

# ╔═╡ 6410b817-b03e-41ff-988a-404e690f0b4c
res_exoarchive = HTTP.get("https://exoplanetarchive.ipac.caltech.edu/TAP/sync";
	query = "query=$(query_exoarchive)"
);

# ╔═╡ b39f8132-bcd4-4ef1-9615-20a2a0ef4a9a
doc_exoarchive = VOTable(String(res_exoarchive.body))

# ╔═╡ 99fb246b-2954-444a-bf62-72abe20ec550
tbl_exoarchive = DataFrame(doc_exoarchive[1])

# ╔═╡ 6c5f7bc1-8475-4e0c-b9bc-065ff3b7dad6
VOTables.units(doc_exoarchive[1])

# ╔═╡ fe26f2ab-df63-4e6a-9200-0cda0b3dbaf7
md"""
!!! question
	Should we expect unit determination to just work™ here?
"""

# ╔═╡ 56d78381-48a7-4f8a-82e6-af635738eab5
md"""
Besides VOTable, we can also download the data as a CSV and handle it as a DataFrame directly:
"""

# ╔═╡ 21f1b4df-1f10-4ca8-aee1-3e4c09b3482f
res_exoarchive_df = HTTP.get("https://exoplanetarchive.ipac.caltech.edu/TAP/sync";
	query = "query=$(query_exoarchive)&format=csv"
);

# ╔═╡ 1c30a30e-f999-44c8-a2c6-be6fdc6fbc04
CSV.read(res_exoarchive_df.body, DataFrame)

# ╔═╡ 8adb03b9-177e-4d7a-b972-b585774f1e5c
TableOfContents()

# ╔═╡ Cell order:
# ╠═19731e2c-a09f-11ec-053c-e5c07ed14eeb
# ╟─e4a3469b-e3cd-4d69-bc0e-7730037dffcf
# ╠═ad392537-8502-4304-b722-c79fbee6edde
# ╠═bf63f661-6983-4b59-b6c6-6527f165aba6
# ╠═fff97d31-471d-4523-8190-8ce05a30eba8
# ╠═274013c1-c691-46a5-bcf0-8e3d6077fdff
# ╠═60dfbacc-42fd-40a2-a0ac-816c287cea11
# ╠═aef54862-2292-4949-b3e7-333667902c9d
# ╟─caf98e0a-aa92-467d-a2eb-b646662e243b
# ╠═fbad1e29-e582-4228-9188-292f096d9862
# ╠═6410b817-b03e-41ff-988a-404e690f0b4c
# ╠═b39f8132-bcd4-4ef1-9615-20a2a0ef4a9a
# ╠═99fb246b-2954-444a-bf62-72abe20ec550
# ╠═6c5f7bc1-8475-4e0c-b9bc-065ff3b7dad6
# ╟─fe26f2ab-df63-4e6a-9200-0cda0b3dbaf7
# ╟─56d78381-48a7-4f8a-82e6-af635738eab5
# ╠═21f1b4df-1f10-4ca8-aee1-3e4c09b3482f
# ╠═1c30a30e-f999-44c8-a2c6-be6fdc6fbc04
# ╟─8adb03b9-177e-4d7a-b972-b585774f1e5c
