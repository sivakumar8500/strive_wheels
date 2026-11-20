import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { getCompanyRiders, assignCompanyRider, updateCompanyRider, deleteCompanyRider } from "../services/api";
import { AssignRiderRequest, UpdateRiderRequest } from "../types";

export const COMPANY_RIDERS_QUERY_KEY = ["companyRiders"];

export function useCompanyRiders() {
  return useQuery({
    queryKey: COMPANY_RIDERS_QUERY_KEY,
    queryFn: getCompanyRiders,
  });
}

export function useAssignCompanyRider() {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: (data: AssignRiderRequest) => assignCompanyRider(data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: COMPANY_RIDERS_QUERY_KEY });
    },
  });
}

export function useUpdateCompanyRider() {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: ({ id, data }: { id: number; data: UpdateRiderRequest }) =>
      updateCompanyRider(id, data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: COMPANY_RIDERS_QUERY_KEY });
    },
  });
}

export function useDeleteCompanyRider() {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: (id: number) => deleteCompanyRider(id),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: COMPANY_RIDERS_QUERY_KEY });
    },
  });
}
