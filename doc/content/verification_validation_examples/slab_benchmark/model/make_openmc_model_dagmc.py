import openmc
import openmc.mgxs as mgxs
import numpy as np
import h5py

T0 = 293
Tmax = 393
Tmin = 293
L0 = 100
L = 106.47
rho = 1.2 # g/cc
N_A = 6.022e23 # Avagadro's number
A = 180 # mass number for slab material
num_dens = rho*N_A/A
P = 1.0e22 # eV/s
q = 1e8 # eV
k0= 1.25e19 # eV/(s-cm-K^2)
phi0 = 2.5e14 # 1/s-cm^2
s = 0.45 # Sigma_s/Sigma_t
f = 1.5 # nu Sigma_f/Sigma_t
nu = f/(1-s)
lam = 0.5*(1+np.sqrt(1+(16*q*q*phi0*phi0)/(P*P)))
Sig_t0 = np.sqrt(P/((lam-1)*k0*L))/(T0) # 1/cm
sig_t0 = Sig_t0/num_dens # cm^2
N = 20
infdim = 0.5

dagmc_univ = openmc.DAGMCUniverse(filename="slab20v.h5m")
geom = openmc.Geometry(root=dagmc_univ)
cells = dagmc_univ.get_all_cells().values()
geom.export_to_xml()

slab = openmc.Material(1, "slab")
slab.set_density('macro',1.)
slab.add_macroscopic('slab_xs')

materials = openmc.Materials([slab])
materials.cross_sections = 'one_group.h5'
materials.export_to_xml()

groups = mgxs.EnergyGroups(group_edges=[0.0, 20.0e6])
NT = 100
temps = np.linspace(Tmin,Tmax,NT)
xsdata = openmc.XSdata('slab_xs', energy_groups=groups, temperatures=temps, num_delayed_groups=0)
xsdata.order = 0

for T in temps:
    Sig_t = (Sig_t0 * T0) / T
    Sig_s = s*Sig_t
    nu_Sig_f = f*Sig_t
    Sig_f = nu_Sig_f / nu
    Sig_a = Sig_f
    xsdata.set_total(np.array([Sig_t]),temperature=T)
    xsdata.set_scatter_matrix(np.array([[[Sig_s]]]),temperature=T)
    xsdata.set_absorption(np.array([Sig_a]),temperature=T)
    xsdata.set_fission(np.array([Sig_f]),temperature=T)
    xsdata.set_nu_fission(np.array([nu_Sig_f]),temperature=T)
    xsdata.set_kappa_fission(np.array([q*Sig_t]),temperature=T)

one_g_XS_file = openmc.MGXSLibrary(groups)
one_g_XS_file.add_xsdata(xsdata)
one_g_XS_file.export_to_hdf5('one_group.h5')

mesh = openmc.RegularMesh()
mesh.dimension = (N,1,1)
mesh.lower_left = (-L/2,-infdim,-infdim)
mesh.upper_right = (L/2,infdim,infdim)

mesh_filter = openmc.MeshFilter(mesh)
tally_global = openmc.Tally()
tally_global.scores = ['kappa-fission']
mgxs_tallies = openmc.Tallies([tally_global])
mgxs_tallies.export_to_xml()

settings = openmc.Settings()
batches = 150
inactive = 50
particles = 50000
settings.energy_mode = 'multi-group'
settings.batches = batches
settings.inactive = inactive
settings.particles = particles
settings.output = {'tallies': True,'summary':False}

bounds = [-60, -infdim, -infdim, 60, infdim, infdim]
uniform_dist = openmc.stats.Box(bounds[:3], bounds[3:])
mu = openmc.stats.Discrete([0.0],[1.0])
phi = openmc.stats.Discrete([0,np.pi],[0.5,0.5])
bidirectional_x = openmc.stats.PolarAzimuthal(mu=mu,phi=phi)
settings.source = openmc.IndependentSource(space=uniform_dist,angle=bidirectional_x)
settings.temperature = {'default': (Tmin+Tmax)/2,
                        'method': 'nearest',
                        'tolerance': 50,
                        'range': (Tmin, Tmax)}
settings.export_to_xml()
