function vc_sub_size = F_gen_subplot_size(v_plots_nb)
%F_GEN_SUBPLOT_SIZE  One description line goes here
%   output_args = F_gen_subplot_size(input_args)   Write here detailed input/ouput arguments list
%  
%   INPUT(S): input arguments description
%      - 
%  
%   OUTPUT(S): output arguments description
%      - 
%  
%   CONTENT: function description
%  
%   CALLS: list of the called functions
%      - 
%  
%   EXAMPLE(S): use(s) case(s) example(s)
%      - 
%  
%  AUTHOR(S): P. Lecharpentier
%  DATE: 07-Jun-2013
%
%  
%  MODIFICATIONS (last commit)
%    $Date: 2013-04-18 14:51:29 +0200 (jeu. 18 avril 2013) $
%    $Author: plecharpent $
%    $Revision: 851 $
%  
% See also F_name1,...(linked/called functions, if none, remove this line)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Production du contenu vc_subplot par fonction f(nb plot)
vc_subplot{1}={1 1};
vc_subplot{2}={2 1};
vc_subplot{3}={2 2};
vc_subplot{4}={2 2};
vc_subplot{5}={3 2};
vc_subplot{6}={3 2};
vc_subplot{7}={4 2};
vc_subplot{8}={4 2};
vc_subplot{9}={3 3};
vc_subplot{10}={4 3};
vc_subplot{11}={4 3};
vc_subplot{12}={4 3};
vc_subplot{13}={5 3};
vc_subplot{14}={5 3};
vc_subplot{15}={5 3};
vc_subplot{16}={4 4};
vc_subplot{17}={5 4};
vc_subplot{18}={5 4};
vc_subplot{19}={5 4};
vc_subplot{20}={5 4};
vc_subplot{21}={7 3};
vc_subplot{22}={5 5};
vc_subplot{23}={5 5};
vc_subplot{24}={5 5};
vc_subplot{25}={5 5};
vc_subplot{26}={5 6};
vc_subplot{27}={5 6};
vc_subplot{28}={5 6};
vc_subplot{29}={5 6};
vc_subplot{30}={5 6};
vc_subplot{31}={6 6};
vc_subplot{32}={6 6};
vc_subplot{33}={6 6};
vc_subplot{34}={6 6};
vc_subplot{35}={6 6};
vc_subplot{36}={6 6};

v_max_plots=length(vc_subplot);

if v_plots_nb<=v_max_plots
   vc_sub_size=vc_subplot{v_plots_nb}; 
else
    error('Too many plots on one figure!');
end
