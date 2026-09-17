"use client";

import { useCompanyProfile } from "../hooks/use-company-profile";
import PageHeader from "@/components/shared/PageHeader";
import { Loader2, Building2, MapPin, Phone, Mail, Wallet, Users, Route, Receipt } from "lucide-react";
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";

export function CompanyProfileDashboard() {
  const { data: profile, isLoading, isError, refetch } = useCompanyProfile();

  if (isLoading) {
    return (
      <div className="flex h-[400px] items-center justify-center">
        <Loader2 className="h-8 w-8 animate-spin text-muted-foreground" />
      </div>
    );
  }

  if (isError || !profile) {
    return (
      <div className="flex h-[400px] flex-col items-center justify-center gap-4 text-red-500">
        <p>Failed to load company profile.</p>
        <Button variant="outline" onClick={() => refetch()}>
          Retry
        </Button>
      </div>
    );
  }

  return (
    <div className="space-y-6">
      <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4">
        <PageHeader
          title="Corporate Dashboard"
          description="Manage your corporate account, view credit balance, and track company-wide commute usage."
        />
        <Badge variant={profile.status === "ACTIVE" ? "default" : "destructive"} className="text-sm px-3 py-1">
          {profile.status}
        </Badge>
      </div>

      <div className="grid gap-6 md:grid-cols-2 lg:grid-cols-3">
        {/* Account Details */}
        <Card className="lg:col-span-2">
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <Building2 className="h-5 w-5 text-primary" />
              Company Details
            </CardTitle>
            <CardDescription>Your registered corporate information.</CardDescription>
          </CardHeader>
          <CardContent>
            <div className="space-y-4">
              <div>
                <h3 className="text-2xl font-bold">{profile.company_name}</h3>
                <p className="text-sm text-muted-foreground font-mono mt-1">
                  Reg No: {profile.registration_number}
                </p>
              </div>

              <div className="grid sm:grid-cols-2 gap-4 pt-4 border-t">
                <div className="space-y-3 text-sm">
                  <div className="flex items-center gap-2 text-muted-foreground">
                    <Phone className="h-4 w-4" />
                    <span className="text-foreground">{profile.contact_person} ({profile.contact_phone})</span>
                  </div>
                  <div className="flex items-center gap-2 text-muted-foreground">
                    <Mail className="h-4 w-4" />
                    <span className="text-foreground">{profile.contact_email}</span>
                  </div>
                </div>
                <div className="space-y-3 text-sm">
                  <div className="flex items-start gap-2 text-muted-foreground">
                    <MapPin className="h-4 w-4 mt-0.5 shrink-0" />
                    <span className="text-foreground leading-relaxed">{profile.address}</span>
                  </div>
                </div>
              </div>
            </div>
          </CardContent>
        </Card>

        {/* Financial Overview */}
        <Card>
          <CardHeader>
            <CardTitle className="flex items-center gap-2">
              <Wallet className="h-5 w-5 text-emerald-600" />
              Financial Overview
            </CardTitle>
            <CardDescription>Billing and credit status.</CardDescription>
          </CardHeader>
          <CardContent>
            <div className="space-y-6">
              <div>
                <p className="text-sm font-medium text-muted-foreground mb-1">Billing Type</p>
                <Badge variant="outline" className="uppercase font-mono tracking-wider">
                  {profile.billing_type}
                </Badge>
              </div>

              <div className="pt-4 border-t">
                <p className="text-sm font-medium text-muted-foreground mb-1">Current Balance</p>
                <h4 className={`text-3xl font-bold ${profile.current_balance < 0 ? 'text-red-600' : 'text-emerald-600'}`}>
                  ${profile.current_balance.toLocaleString()}
                </h4>
                {profile.billing_type === "POSTPAID" && (
                  <p className="text-xs text-muted-foreground mt-2">
                    Credit Limit: ${profile.credit_limit.toLocaleString()}
                  </p>
                )}
                {profile.billing_type === "PREPAID" && (
                  <p className="text-xs text-muted-foreground mt-2">
                    Please ensure balance remains positive.
                  </p>
                )}
              </div>
            </div>
          </CardContent>
        </Card>
      </div>

      <div className="grid gap-6 md:grid-cols-3">
        <Card>
          <CardHeader className="flex flex-row items-center justify-between pb-2">
            <CardTitle className="text-sm font-medium text-muted-foreground">
              Active Employees
            </CardTitle>
            <Users className="h-4 w-4 text-blue-600" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">{profile.stats.active_employees}</div>
            <p className="text-xs text-muted-foreground mt-1">
              Registered for corporate rides
            </p>
          </CardContent>
        </Card>
        
        <Card>
          <CardHeader className="flex flex-row items-center justify-between pb-2">
            <CardTitle className="text-sm font-medium text-muted-foreground">
              Trips This Month
            </CardTitle>
            <Route className="h-4 w-4 text-orange-600" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">{profile.stats.total_trips_this_month}</div>
            <p className="text-xs text-muted-foreground mt-1">
              Across {profile.stats.active_shuttle_routes} active shuttle routes
            </p>
          </CardContent>
        </Card>

        <Card>
          <CardHeader className="flex flex-row items-center justify-between pb-2">
            <CardTitle className="text-sm font-medium text-muted-foreground">
              Monthly Spend
            </CardTitle>
            <Receipt className="h-4 w-4 text-purple-600" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">${profile.stats.total_spend_this_month.toLocaleString()}</div>
            <p className="text-xs text-muted-foreground mt-1">
              Estimated total for current billing cycle
            </p>
          </CardContent>
        </Card>
      </div>
    </div>
  );
}
