function output_struct=xmltree2full(v_xmltree,elt_uid)

if ~nargin
    return
else
    v_xmltree_type = xmlDocument.getStructType(v_xmltree);
    if strcmp('unknown',v_xmltree_type)
       return 
    end
end

output_struct=struct;
output_struct.ATTRIBUTE='';

if ~exist('elt_uid','var')
    if isa(v_xmltree,'xmltree')
        start_uid=root(v_xmltree);
    else % not used for struct at this time!
        start_uid=1;
    end
else
    start_uid=elt_uid;
end

v_childs_elts=getChildren(v_xmltree,start_uid);

if isempty(v_childs_elts)
    return
end

% traitement xmltree object
for i=1:length(v_childs_elts) 
    
    switch v_xmltree_type
        case 'tree_obj'
            elt=v_childs_elts{i};
            elt_type=elt.type;
            
        case 'tree_struct'
            elt=v_childs_elts(i);
            if strcmp(elt.Name,'#comment')
                elt_type='comment';
            
            elseif strcmp(elt.Name,'#text')
                elt_type='chardata';
                
            elseif isempty(strfind(elt.Name,'#'))
                elt_type='element';
            end
    end
    
    
    switch elt_type
        case 'comment'
            continue
            
        case 'chardata'
            % for obj
            if isfield(elt,'value')
                output_struct.CONTENT=elt.value;
            end
            % for struct
            if isfield(elt,'Data') && (any(isletter(elt.Data)) ||...
                    ~isnan(str2double(elt.Data)))
                output_struct.CONTENT=elt.Data;
            end
        case 'element'
            switch v_xmltree_type
                case 'tree_obj'
                    if ~isfield(output_struct,elt.name)
                        output_struct.(elt.name)=xmltree2full(v_xmltree,elt.uid);
                        if isempty(elt.contents)
                           output_struct.(elt.name).CONTENT=''; 
                        end
                    else
                        if ~iscell(output_struct.(elt.name))
                            output_struct.(elt.name)={output_struct.(elt.name)};
                        end
                        output_struct.(elt.name){end+1}=xmltree2full(v_xmltree,elt.uid);
                    end                 
                    % Attributes treatment
                    if ~isempty(elt.attributes)
                        if ~iscell(output_struct.(elt.name))
                            for j=1:length(elt.attributes)
                                output_struct.(elt.name).ATTRIBUTE.(elt.attributes{j}.key)=elt.attributes{j}.val;
                            end
                        else
                            for j=1:length(elt.attributes)
                                output_struct.(elt.name){end}.ATTRIBUTE.(elt.attributes{j}.key)=elt.attributes{j}.val;
                            end
                        end
                    end
                    
                case 'tree_struct'
                    % A REVOIR !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
                    
                    if ~isempty(v_childs_elts(i))
                        if ~isfield(output_struct,elt.Name)
                            output_struct.(elt.Name)=xmltree2full(v_childs_elts(i),1,output_struct);
                        else
                            if iscell(output_struct.(elt.Name))
                                output_struct.(elt.Name){end+1}=xmltree2full(v_childs_elts(i),1,output_struct);
                            else
                                output_struct.(elt.Name)={output_struct.(elt.Name)};
                                output_struct.(elt.Name){2}=xmltree2full(v_childs_elts(i),1,output_struct);
                            end
                        end
                    else
                        output_struct.(elt.Name).CONTENT='';
                        if isfield(elt,'Data') && isempty(elt.Children)
                            output_struct.(elt.Name).CONTENT=elt.Data;
                        end
                        
                    end
                    
                    if ~isempty(elt.Attributes)
                        for j=1:length(elt.Attributes)
                            if isstruct(elt.Attributes)
                                output_struct.(elt.Name).ATTRIBUTE.(elt.Attributes.Name)=elt.Attributes.Value;
                            elseif iscell(elt.Attributes)
                                output_struct.(elt.Name).ATTRIBUTE.(elt.Attributes{j}.Name)=elt.Attributes{j}.Value;
                            end
                        end
                    end
                    

                    
            end
        otherwise
            disp([elt.type ': not treated yet !'])   
    end
end



    function v_children_elts=getChildren(xmltree_elt,v_uid)
        v_children_elts=[];
        if isa(xmltree_elt,'xmltree')
            vv_children_uid = children(xmltree_elt,v_uid);
            v_nb_children=length(vv_children_uid);
            v_children_elts=cell(1,v_nb_children);
            for child_idx=1:v_nb_children
                v_children_elts{child_idx}=get(xmltree_elt,vv_children_uid(child_idx));
            end
            
        elseif isstruct(xmltree_elt) && ...
                isempty(setdiff({'Name' 'Attributes' 'Data' 'Children'},fieldnames(xmltree_elt)))
            for ielt=1:size(xmltree_elt,2)
                if ~isempty(xmltree_elt(ielt).Children)
                    v_children_elts = xmltree_elt(ielt).Children;
                    break
                end
            end
        end
    end


    
end