"use client";
import React, { useState, useEffect } from "react";
import { useForm, FormProvider } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import { motion } from "framer-motion";

import AuthLayout from "@/features/auth/components/AuthLayout";
import { useLogin } from "@/features/auth/hooks/use-login";
import {
  loginSchema,
  type LoginFormInputs,
} from "@/features/auth/validations/login-schema";
import TextInput from "@/components/forms/TextInput";
import PasswordInput from "@/components/forms/PasswordInput";
import { Checkbox } from "@/components/ui/checkbox";
import { Button } from "@/components/ui/button";

export default function LoginFormClient() {
  const [error, setError] = useState<React.ReactNode>("");
  const [isBlocked, setIsBlocked] = useState(false);

  const form = useForm<LoginFormInputs>({
    resolver: zodResolver(loginSchema),
    defaultValues: {
      email: "",
      password: "",
    },
    mode: "onTouched",
  });

  const {
    handleSubmit,
    formState: { isValid },
    watch,
  } = form;

  const { mutate: login, isPending: isEmailLoginPending } = useLogin();

  const email = watch("email");
  const password = watch("password");

  useEffect(() => {
    if (error) setError("");
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [email, password]);

  const onSubmitEmail = (data: LoginFormInputs) => {
    if (isBlocked) return;
    setError("");

    login(
      { email: data.email, password: data.password },
      {
        onError: (err: unknown) => {
          const error = err as { message?: string };
          const errorMessage = error?.message || String(error);

          if (errorMessage.toLowerCase().includes("block")) setIsBlocked(true);
          setError(errorMessage);
        },
      },
    );
  };

  return (
    <AuthLayout>
      <div className="flex flex-col gap-10">
        <div className="flex flex-col gap-3">
          <motion.div
            initial={{ opacity: 0, x: -20 }}
            animate={{ opacity: 1, x: 0 }}
            transition={{ duration: 0.5, delay: 0.1 }}
          >
            <h1 className="text-4xl font-extrabold tracking-tight text-slate-900">
              Welcome back
            </h1>
            <p className="text-base text-slate-500 mt-2">
              Please enter your details to sign in.
            </p>
          </motion.div>
        </div>

        {error && (
          <motion.div 
            initial={{ opacity: 0, y: -10 }}
            animate={{ opacity: 1, y: 0 }}
            className="p-4 rounded-xl bg-red-50 border border-red-200 text-red-600 text-sm font-medium"
          >
            {error}
          </motion.div>
        )}

        <FormProvider {...form}>
          <form
            onSubmit={handleSubmit(onSubmitEmail)}
            className="flex flex-col gap-6"
          >
            <div className="flex flex-col gap-5">
              <motion.div
                initial={{ opacity: 0, y: 10 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ duration: 0.5, delay: 0.2 }}
              >
                <TextInput
                  name="email"
                  label="Email"
                  placeholder="name@example.com"
                  disabled={isEmailLoginPending}
                  labelClassName="text-sm font-semibold text-slate-700"
                  className="h-12 rounded-xl bg-slate-50/50 border-slate-200 focus:bg-white transition-colors"
                />
              </motion.div>

              <motion.div
                initial={{ opacity: 0, y: 10 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ duration: 0.5, delay: 0.3 }}
              >
                <PasswordInput
                  name="password"
                  label="Password"
                  placeholder="••••••••"
                  disabled={isEmailLoginPending}
                  labelClassName="text-sm font-semibold text-slate-700"
                  className="h-12 rounded-xl bg-slate-50/50 border-slate-200 focus:bg-white transition-colors"
                />
              </motion.div>
            </div>

            <motion.div 
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              transition={{ duration: 0.5, delay: 0.4 }}
              className="flex items-center justify-between mt-2"
            >
              <div className="flex items-center gap-2.5">
                <Checkbox id="remember" className="h-5 w-5 rounded-md border-slate-300 text-blue-600 focus:ring-blue-500" />
                <label
                  htmlFor="remember"
                  className="text-sm text-slate-600 font-medium cursor-pointer select-none"
                >
                  Remember me
                </label>
              </div>
              <a href="#" className="text-sm font-semibold text-blue-600 hover:text-blue-700 transition-colors">
                Forgot password?
              </a>
            </motion.div>

            <motion.div
              initial={{ opacity: 0, y: 10 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ duration: 0.5, delay: 0.5 }}
              className="mt-4"
            >
              <Button
                type="submit"
                disabled={!isValid || isEmailLoginPending || isBlocked}
                className="w-full h-12 rounded-xl bg-gradient-to-r from-blue-600 to-indigo-600 hover:from-blue-700 hover:to-indigo-700 text-white text-base font-semibold shadow-lg shadow-blue-500/30 transition-all hover:shadow-blue-500/40 active:scale-[0.98]"
              >
                {isEmailLoginPending ? "Signing in..." : "Sign In"}
              </Button>
            </motion.div>
          </form>
        </FormProvider>
      </div>
    </AuthLayout>
  );
}
