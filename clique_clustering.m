function [set_clusters] = clique_clustering(connectivity_matrix)
%s.rossi@ucl.ac.uk

%%%Given the connectivity matrix this function find all clustering based on
%%%maximal cliques
n_elements = size(connectivity_matrix,1);
connectivity_matrix = connectivity_matrix - diag(ones(n_elements,1));
clustered_users = zeros(1,n_elements);
missing_users = 1:n_elements;
set_clusters = zeros(1,n_elements);
index =1;

    while sum(clustered_users) < n_elements

        %%Find maximal cliques using Bron-Kerbosch algorithm
        cliques_dist=maximalCliques(connectivity_matrix(missing_users,missing_users));

        for r = 1:size(cliques_dist,2)
            all_clique{r} = find(cliques_dist(:,r));
            all_clique{r} = missing_users(all_clique{r});
        end

        %Descending order
        [len_cluster,order_cluster] = sort(cellfun('length', all_clique),'descend' );

        %Ordering clique
        all_clique = all_clique(order_cluster);
        clear len_cluster order_cluster
        
        set = all_clique{1};
        set_clusters(set)=index;
        missing_users = find(set_clusters==0);
        clustered_users(set) = clustered_users(set) + 1;
        index = index + 1;
        clear set all_clique
    end

end


