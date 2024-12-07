%% Estrazione file del clima dal file generale .CLI

function fCLI=climatex(CLI)
cliname=CLI(1:(length(CLI)));
fCLI(1)=mat2cell([cliname '.CLI']);
fCLI(2)=mat2cell([cliname '.TMP']);
fCLI(3)=mat2cell([cliname '.ETo']);
fCLI(4)=mat2cell([cliname '.PLU']);
fCLI(5)=mat2cell('MaunaLoa.CO2');


