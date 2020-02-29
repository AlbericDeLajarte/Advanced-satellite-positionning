function [toe_index, M0_index, sqrta_index, deltan_index,...
    ecc_index, omega_index, cwc_index, cws_index, crc_index, ...
    crs_index, i0_index, idot_index, cic_index, cis_index, ...
    omega0_index, omegadot_index] = find_indices(info)

toe_index = find(strcmp(info, 'toe'));
M0_index = find(strcmp(info, 'm0'));
sqrta_index = find(strcmp(info, 'sqrta'));
deltan_index = find(strcmp(info, 'deltan'));
ecc_index = find(strcmp(info, 'ecc'));
omega_index = find(strcmp(info, 'omega'));
cwc_index = find(strcmp(info, 'cuc'));
cws_index = find(strcmp(info, 'cus'));
crc_index = find(strcmp(info, 'crc'));
crs_index = find(strcmp(info, 'crs'));
i0_index = find(strcmp(info, 'i0'));
idot_index = find(strcmp(info, 'idot'));
cic_index = find(strcmp(info, 'cic'));
cis_index = find(strcmp(info, 'cis'));
omega0_index = find(strcmp(info, 'omega0'));
omegadot_index = find(strcmp(info, 'omegadot'));

